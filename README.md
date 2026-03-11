# HR MatchPoint Engine (T-SQL)

## Overview
This project is an asynchronous technical test for Datapizza. 
While many recruiting apps focus on the front-end, I decided to tackle the core problem: **how to efficiently match candidates to job requirements at scale.**

Coming from a background as a Senior Database Administrator, I built a Backend Matching Engine purely in T-SQL. 

## What This Project Does
Instead of simply returning a list of candidates, this engine calculates a weighted `TotalMatchScore` and ranks candidates in real-time.

1. **Normalized Architecture:** Separates Candidates, Skills, and Jobs into a 3NF relational model.
2. **Weighted Scoring:** Multiplies a candidate's `ProficiencyLevel` (1-5) by the job's `Importance` weight (1-3) for that specific skill.
3. **Advanced T-SQL:** Uses `DENSE_RANK()` window functions to instantly assign a 1st, 2nd, and 3rd place rank to candidates based on their total score.

## How to Run It
The `matching_engine.sql` file contains everything needed:
1. The table creation scripts.
2. Mock data (Fake candidates, jobs, and skills).
3. The Stored Procedure (`usp_RankCandidatesForJob`).
4. An execution command at the bottom to test the engine.
