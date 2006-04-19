From: David Greaves <david@dgreaves.com>
Subject: Re: Raid5 says it's rebuilding, but it lies :)
Date: Wed, 19 Apr 2006 10:32:21 +0100
Message-ID: <444603A5.6060806@dgreaves.com>
References: <13525.1145408657@www047.gmx.net> <17477.37593.650885.214484@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17477.37593.650885.214484@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Schricker <k_schricker@gmx.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday April 19, k_schricker@gmx.net wrote:
>   
>> I have a raid5 configuration with 4 disks, of which all were active.  My
>> system froze due to a separate issue (firewire), so I had to power cycle. 
>> In the past, I've always been able to recover with fsck on /dev/md0, however
>> this time I was not, and I am unable to re-assemble the array now.
>>
>> I'm really hoping someone can help me with this.  I've been googling and
>> reading the mdadm manpage for 3 days and getting nowhere.
>>
>> After booting, I get 3 active disks and one faulty.  Theoretically with
>> raid5 I should be able to recover from this, right? :)  When I add it back
>> to the array, it changes to "spare rebuilding".  However it lies: no Rebuild
>> Status ever shows up (and I let it run overnight).
>>     
>
> Hmmm... there is certainly room for removing confusion from that
> "mdadm -D" is reporting.  However what you want to do it:
>
>  mdadm -S /dev/md0
>  mdadm -A /dev/md0 --force /dev/sd[abd]
>  mdadm /dev/md0 --add /dev/sdv
>   
Typo: this last line should be:

mdadm /dev/md0 --add /dev/sdc
                            ^

David


