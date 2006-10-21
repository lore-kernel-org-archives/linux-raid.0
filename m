From: Bodo Thiesen <bothie@gmx.de>
Subject: Re: why partition arrays?
Date: Sat, 21 Oct 2006 06:26:48 +0200
Message-ID: <20061021062648.23c0bd7a@30_bodo.rupinet>
References: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
Cc: Ken Walker <ken.walker@manchester.ac.uk>
List-Id: linux-raid.ids

Ken Walker <ken.walker@manchester.ac.uk> wrote:

> Is LVM stable, or can it cause more problems than separate raids on a array.

I don't know what you consider "stable". But let me explain what we have 
running here for now, maybe you will then have a better feeling on how 
stable LVM is:

After two hard disks crashed, and we loosed more ore less semi-important 
data, we considered to set up all disk space using RAID6.

The initial situation was: We had 7 hard discs with more or less different 
sizes. So just using the block devices for the raids was not optimal. We 
didn't want to waste TOO much space (we were going to "waste" 2/5 through 
RAID6 already, that is 40%, but another 50% by orienting on the smallest 
disc was out of the questions). So we decided to create four RAID6 arrays 
each using five block devices. There were the sizes ~100GB, ~75GB and 
2*~55GB. So we could fully utilize our new discs of ~300GB each, and still 
meaningful use the other disks - all smaller in size. But with this strange 
concept we immediately decided, that just using IBM disk labels (aka 
partitions) were not really meaningful, especially as after swapping discs 
(consider changing the chassis, just disconnecting all discs ... hmm, what 
was hdb and what was hdd? And hde? Hmmm ...), so we decided the following 
structure:

hda -> vg called raida -> creating LVs called raida1..raida4
hdb -> vg called raidb -> creating LVs called raidb1..raidb4

and so on

On some discs, not all of raidX1..raidX4 were actually created, e.g. on 
our 200GB disc, only raidX2..raidX4 were creates thus missing the 100GB 
component.

Now, raid*1 would make up md1, raid*2 would build md2 and so on.

Each of md1..md4 where then created another VG on, all put in one volume 
group (called 'space' ;), and from that VG we created our actual logical 
volumes like homes etc.

BTW: I left off the dm-crypt step, additionally the raid LVs are all 
encrypted.

That system is now stable at least since 14. Feb 2006.

So, now decide for your own, if you consider LVM stable - I would ;)

Regards, Bodo
