From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Stress testing system?
Date: Mon, 11 Oct 2004 13:01:27 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416A4BE7.4030005@wasp.net.au>
References: <4167078A.3030609@robinbowes.com> <Pine.LNX.4.56.0410082257450.26162@lion.drogon.net> <4167264B.8070507@robinbowes.com> <Pine.LNX.4.56.0410102122140.9395@lion.drogon.net> <4169AB0B.1040709@robinbowes.com> <Pine.LNX.4.56.0410110919530.9395@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0410110919530.9395@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: Robin Bowes <robin-lists@robinbowes.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:
> On Sun, 10 Oct 2004, Robin Bowes wrote:
> 
> 
>>This gave the following results:
>>
>>Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
>>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
>>Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
>>dude.robinbow 3096M 13081  95 34159  75 12617  21 15311  92 40429  30 436.1   3
>>dude.robinbowes.com,3096M,13081,95,34159,75,12617,21,15311,92,40429,30,436.1,3,,,,,,,,,,,,,
>>
>>I don't actually know what the figures mean - is this fast??
> 
> 
> It's not brilliant, but reasonable for a RAID5 on IDE drives. Disk head
> bandwidth for comodity 7200 RPM drives is about 55MB/sec peak - although I
> haven't been able to get that with the SATA controllers I've used so-far,
> but I suspect thats because they are running in PATA mode.
> 

Just a point of reference. This is on a single Athlon 2600+ with 10 7200 RPM Maxtor drives on 3 
Promise SATA150TX4 controllers

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
srv              1G 14502  45 23251  12 17102   9 23390  67 67688  24 638.4   1
srv,1G,14502,45,23251,12,17102,9,23390,67,67688,24,638.4,1,,,,,,,,,,,,,

Brad
