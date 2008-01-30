From: Janek Kozicki <janek_listy@wp.pl>
Subject: which raid level gives maximum overall speed? (raid-10,f2 vs.
 raid-0)
Date: Wed, 30 Jan 2008 19:21:33 +0100
Message-ID: <20080130192133.17b254bf@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Yes, I know that some levels give faster reading and slower writing, etc.

I want to talk here about a typical workstation usage: compiling
stuff (like kernel), editing openoffice docs, browsing web, reading
email (email: I have a webdir format, and in boost mailing list
directory I have 14000 files (posts), opening this directory takes
circa 10 seconds in sylpheed). Moreover, opening .pdf files, more
compiling of C++ stuff, etc...

I have a remote backup system configured (with rsnapshot), which does
backups two times a day. So I'm not afraid to lose all my data due to
disc failure. I want absolute speed.

Currently I have Raid-0, because I was thinking that this one is
fastest. But I also don't need twice the capacity. I could use Raid-1
as well, if it was faster.

Due to recent discussion about Raid-10,f2 I'm getting worried that
Raid-0 is not the fastest solution, but instead a Raid-10,f2 is
faster.

So how really is it, which level gives maximum overall speed?


I would like to make a benchmark, but currently, technically, I'm not
able to. I'll be able to do it next month, and then - as a result of
this discussion - I will switch to other level and post here
benchmark results.

How does overall performance change with the number of available drives?

Perhaps Raid-0 is best for 2 drives, while Raid-10 is best for 3, 4
and more drives?


best regards
-- 
Janek Kozicki                                                         |
