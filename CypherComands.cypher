\\ Importa os Json salvos na pasta import do Neo4j
CALL apoc.load.directory('*.json')
YIELD value
UNWIND value AS arquivo

WITH arquivo
CALL apoc.load.json(arquivo)
YIELD value
UNWIND value.data AS tweet

MERGE (t:Tweet {tweet_id: tweet.id})
ON CREATE SET 
  t.text = tweet.text,
  t.created_at = datetime(tweet.created_at),
  t.conversation_id = tweet.conversation_id

FOREACH (ref_tweet IN tweet.referenced_tweets |
  SET t.tipo_ref = coalesce(t.tipo_ref, []) + [ref_tweet.type],
  t.id_ref = coalesce(t.id_ref, []) + [ref_tweet.id]
)

MERGE (u:User {user_id: tweet.author_id})
MERGE (u)-[:TUITOU]->(t)

WITH t, tweet, tweet.entities.hashtags AS hashtags
UNWIND hashtags AS hashtag
WITH t, apoc.text.replace(apoc.text.clean(hashtag.tag), '[^a-zA-Z0-9]', '') AS cleanedHashtag
MERGE (h:Hashtag {tag: cleanedHashtag})
MERGE (t)-[:POSSUI]->(h);

// Exibir os Retweets
MATCH (t:Retweet)
RETURN t;


// Exibir as Respostas
MATCH (t:Resposta)
RETURN t;


// Exibir as Citações
MATCH (t:Citacao)
RETURN t;


MATCH (t:Tweet)-[:POSSUI]->(h:Hashtag) 
WHERE NOT EXISTS ((t)-[:TUITOU]->(:Retweet)) 
  AND NOT EXISTS ((t)-[:TUITOU]->(:Resposta))
  AND NOT EXISTS ((t)-[:TUITOU]->(:Citacao))
RETURN h.tag AS hashtag, COUNT(t) AS total
ORDER BY total DESC
LIMIT 1;


MATCH (h:Hashtag {tag: 'issoaglobonaomostra'})<-[:POSSUI]-(t:Tweet)
WHERE NOT EXISTS ((t)-[:TUITOU]->(:Retweet))
  AND NOT EXISTS ((t)-[:TUITOU]->(:Resposta))
  AND NOT EXISTS ((t)-[:TUITOU]->(:Citacao))
RETURN h, t

MATCH (u:User)-[:TUITOU]->(t:Tweet)
RETURN u.user_id AS user, COUNT(t) AS total_tweets
ORDER BY total_tweets DESC
LIMIT 1;

MATCH (u:User {user_id: '1241726651635032065'})-[:TUITOU]->(t:Tweet)
RETURN u, t
LIMIT 10;


