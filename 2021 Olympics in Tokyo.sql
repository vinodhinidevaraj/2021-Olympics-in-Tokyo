-- Join all five tables together
SELECT 
    A.Name AS Athlete_Name, 
    A.NOC AS Athlete_NOC, 
    A.Discipline AS Athlete_Discipline,
    C.Name AS Coach_Name, 
    C.Event AS Coach_Event,
    EG.Female, 
    EG.Male, 
    EG.Total AS Total_Entries,
    M.Rank, 
    M.Team_NOC,
    M.Gold, 
    M.Silver, 
    M.Bronze, 
    M.Total AS Total_Medals,
    T.Name AS Team_Name, 
    T.Event AS Team_Event
FROM 
    Athletes A
LEFT JOIN 
    Coaches C ON A.NOC = C.NOC AND A.Discipline = C.Discipline
LEFT JOIN 
    EntriesGender EG ON A.Discipline = EG.Discipline
LEFT JOIN 
    Medals M ON A.NOC = M.Team_NOC
LEFT JOIN 
    Teams T ON A.NOC = T.NOC AND A.Discipline = T.Discipline;



-- Medal Analysis: Calculating the total number of gold, silver, and bronze medals won by each country

SELECT 
    Team_Name AS Country,
    SUM(Gold) AS Total_Gold_Medals,
    SUM(Silver) AS Total_Silver_Medals,
    SUM(Bronze) AS Total_Bronze_Medals,
    SUM(Gold + Silver + Bronze) AS Total_Medals
FROM 
    (
    SELECT 
        M.Team_NOC AS Team_NOC,
        M.Gold AS Gold,
        M.Silver AS Silver,
        M.Bronze AS Bronze,
        T.Name AS Team_Name
    FROM 
        Medals M
    LEFT JOIN 
        Teams T ON M.Team_NOC = T.NOC
    ) AS MedalData
GROUP BY 
    Team_Name
ORDER BY 
    Total_Medals DESC;

--Participant Analysis

-- Count the total number of athletes and coaches from each country
SELECT 
    A.NOC AS Country,
    COUNT(DISTINCT A.Name) AS Total_Athletes,
    COUNT(DISTINCT C.Name) AS Total_Coaches,
    COUNT(DISTINCT A.Name) + COUNT(DISTINCT C.Name) AS Total_Participants
FROM 
    Athletes A
LEFT JOIN 
    Coaches C ON A.NOC = C.NOC
GROUP BY 
    A.NOC
ORDER BY 
    Total_Participants DESC;


-- Analyze the gender distribution of participants in different disciplines
SELECT 
    Discipline,
    SUM(Female) AS Total_Female_Participants,
    SUM(Male) AS Total_Male_Participants,
    SUM(Female) + SUM(Male) AS Total_Participants
FROM 
    EntriesGender
GROUP BY 
    Discipline
ORDER BY 
    Total_Female_Participants DESC;


--coach Analysis
-- Evaluate the performance of coaches based on the success of their athletes
SELECT 
    C.Name AS Coach_Name,
    COUNT(DISTINCT A.Name) AS Total_Athletes,
    SUM(M.Gold) AS Total_Gold_Medals,
    SUM(M.Silver) AS Total_Silver_Medals,
    SUM(M.Bronze) AS Total_Bronze_Medals,
    SUM(M.Gold + M.Silver + M.Bronze) AS Total_Medals
FROM 
    Coaches C
LEFT JOIN 
    Athletes A ON C.NOC = A.NOC AND C.Discipline = A.Discipline
LEFT JOIN 
    Medals M ON A.NOC = M.Team_NOC
GROUP BY 
    C.Name
ORDER BY 
    Total_Medals DESC;

-- Identify coaches associated with the most successful teams or athletes
SELECT 
    C.Name AS Coach_Name,
    T.Name AS Team_Name,
    T.Discipline AS Team_Discipline,
    SUM(M.Gold) AS Total_Gold_Medals,
    SUM(M.Silver) AS Total_Silver_Medals,
    SUM(M.Bronze) AS Total_Bronze_Medals,
    SUM(M.Gold + M.Silver + M.Bronze) AS Total_Medals
FROM 
    Coaches C
LEFT JOIN 
    Teams T ON C.NOC = T.NOC AND C.Discipline = T.Discipline
LEFT JOIN 
    Medals M ON T.NOC = M.Team_NOC
GROUP BY 
    C.Name, T.Name, T.Discipline
ORDER BY 
    Total_Medals DESC;

-- Analyze the distribution of coaches across different disciplines
SELECT 
    Discipline,
    COUNT(DISTINCT Name) AS Total_Coaches
FROM 
    Coaches
GROUP BY 
    Discipline;


--Discipline Analysis
-- Analyze the distribution of athletes and medals across different disciplines
SELECT 
    A.Discipline,
    COUNT(DISTINCT A.Name) AS Total_Athletes,
    SUM(M.Gold) AS Total_Gold_Medals,
    SUM(M.Silver) AS Total_Silver_Medals,
    SUM(M.Bronze) AS Total_Bronze_Medals,
    SUM(M.Gold + M.Silver + M.Bronze) AS Total_Medals
FROM 
    Athletes A
LEFT JOIN 
    Medals M ON A.NOC = M.Team_NOC
GROUP BY 
    A.Discipline
ORDER BY 
    Total_Medals DESC;

-- Identify disciplines where certain countries excel or underperform
SELECT 
    A.Discipline,
    M.Team_NOC AS Country,
    SUM(M.Gold) AS Total_Gold_Medals,
    SUM(M.Silver) AS Total_Silver_Medals,
    SUM(M.Bronze) AS Total_Bronze_Medals,
    SUM(M.Gold + M.Silver + M.Bronze) AS Total_Medals
FROM 
    Athletes A
LEFT JOIN 
    Medals M ON A.NOC = M.Team_NOC
GROUP BY 
    A.Discipline, M.Team_NOC
ORDER BY 
    Total_Medals DESC;

-- Determine the most competitive disciplines based on the number of participants and medals awarded
SELECT 
    A.Discipline,
    COUNT(DISTINCT A.Name) AS Total_Athletes,
    COUNT(DISTINCT M.Team_NOC) AS Total_Countries,
    SUM(M.Gold + M.Silver + M.Bronze) AS Total_Medals
FROM 
    Athletes A
LEFT JOIN 
    Medals M ON A.NOC = M.Team_NOC
GROUP BY 
    A.Discipline
ORDER BY 
    Total_Athletes DESC, Total_Medals DESC;

