From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: RAID1 assembled broken array
Date: Tue, 15 Sep 2009 19:33:19 +0000
Message-ID: <1253043199.7774.179.camel@kiste>
References: <h8ophd$n8p$6@ger.gmane.org>
	 <70ed7c3e0909151224s75cd6c60kc65c2f4e9076e649@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909151224s75cd6c60kc65c2f4e9076e649@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-09-15 at 22:24 +0300, Majed B. wrote:
> Specifying partition names may cause problems if the disk names
> changed. Specify the UUID instead.
> 
What I was trying to say is "use a pattern that matches all of your
partitions and none of your actual disks". That should be safe from
changing disk file names.

Besides, specifying UUIDs does not work because it runs into the exact
problem we're trying to solve in the first place. Behold the "blkid"
output from the server in question:

/dev/sdb2: UUID="1583e643-7004-a86e-4eff-81c58ea53278" TYPE="mdraid" 
/dev/sdb: UUID="1583e643-7004-a86e-4eff-81c58ea53278" TYPE="mdraid" 

Interestingly, for some reason it doesn't do that with /dev/sda -- most
probably because the disks in question use different head/sector values
and thus have slightly different partition layout.

