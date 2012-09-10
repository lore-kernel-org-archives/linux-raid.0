From: =?iso-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Howto avoid full re-sync
Date: Mon, 10 Sep 2012 16:12:44 +0200
Message-ID: <C0796F33-32E4-4F28-B6FB-469AF438C545@bj-ig.de>
References: <50497AE6.2010005@websitemanagers.com.au> <81BAA7A8-B1C3-49A1-A600-A9D9D8279E30@bj-ig.de> <504D223A.6020707@websitemanagers.com.au>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <504D223A.6020707@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Am 10.09.2012 um 01:11 schrieb Adam Goryachev:
>> 
>> Besides all the stuff about fix your server, a raid is not a backup and you risk your data - simply add a write intent bitmap:
>> 
>> # mdadm /dev/md2 --grow bitmap=internal
>> 
> mdadm /dev/md2 --grow bitmap=internal
> mdadm: can only add devices to linear arrays
> 

My fault: 

mdadm /dev/md2 --grow --bitmap=internal

Ralf


