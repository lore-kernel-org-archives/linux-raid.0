From: Harry Mangalam <hjm@tacgi.com>
Subject: Re: 3ware + RAID5 + xfs performance
Date: Wed, 27 Jul 2005 09:15:31 -0700
Message-ID: <200507270915.32011.hjm@tacgi.com>
References: <Pine.SOL.4.58.0507252110320.2683@titan.cfa.harvard.edu> <200507252134.13869.hjm@tacgi.com> <20050727092104.GA6215@ii.uib.no>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-xfs-bounce@oss.sgi.com>
In-Reply-To: <20050727092104.GA6215@ii.uib.no>
Content-Disposition: inline
Sender: linux-xfs-bounce@oss.sgi.com
Errors-to: linux-xfs-bounce@oss.sgi.com
To: Jan-Frode Myklebust <Jan-Frode.Myklebust@bccs.uib.no>
Cc: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

That's very impressive!  How many config iterations did you have to do to get 
this perf? 

You can't see it from his log of commands but one thing about XFS for tuning 
is that unlike ext3 or even reiserfs, it takes only a sec or so to create 
even a very large filesystem so you can try one set of params, run your tests 
then rewrite the filesystem with different parameters to try another.

 I should mention that we need redundant space more than speed and that our 
journal is on the RAID system - it looks like Jan has his on an external 
device which is rec for extra speed (journal writes don't compete for i/o 
bandwidth with data).

I'd certainly consider GPFS but I was under the impression that it was only 
available for IBM-branded Linux boxes w/ customized kernels.  Can you buy it 
a la carte?

hjm


On Wednesday 27 July 2005 02:21, Jan-Frode Myklebust wrote:
> On Mon, Jul 25, 2005 at 09:34:13PM -0700, Harry Mangalam wrote:
> > I went thru the same hardware config gymnastics
>
> me too, but for RAID0, so here are my numbers for show-off, since I was
> quite impressed with them. HW is 3ware 8506-8 with 8 Maxtor 7Y250M0 250 GB
> drives, on a dual 2.4 GHz Xeon with 2 GB memory. Running RHEL3 (probably
> around update 1).
>
> 3ware CLI> maint createunit c0 rraid0 k64k p0:1:2:3:4:5:6:7
> # mkfs.xfs -d sunit=128,swidth=1024 -l
> logdev=/dev/hdb1,version=2,size=18065b -f  /dev/sda1 # mount -o
> noatime,logbufs=8,logdev=/dev/hdb1 /dev/sda1 /mnt/sda1
> % bonnie++ -f -x 5
> hydra.ii.uib.no,4G,,,185270,64,73385,28,,,167514,31,506.5,1,16,6076,34,++++
>+,+++,5274,28,6079,25,+++++,+++,4519,31
> hydra.ii.uib.no,4G,,,211922,68,72763,28,,,170114,30,496.9,0,16,6118,31,++++
>+,+++,5307,45,6112,39,+++++,+++,4546,29
> hydra.ii.uib.no,4G,,,207263,75,73464,28,,,177586,33,478.6,2,16,6072,32,++++
>+,+++,5291,31,6135,43,+++++,+++,4524,37
> hydra.ii.uib.no,4G,,,213538,77,72984,28,,,176985,33,488.6,1,16,6147,43,++++
>+,+++,5277,23,6161,41,+++++,+++,4505,28
> hydra.ii.uib.no,4G,,,202534,62,72048,27,,,164839,30,522.8,1,16,6130,46,++++
>+,+++,5274,33,6158,52,+++++,+++,4516,28
>
> > We are now considering adding a local PVFS2 system to a small cluster for
> > very fast IO under MPI
>
> We use IBM's GPFS for our cluster (85 dual opterons + 3 storage
> nodes), and have only positive experience with it..
>
>
>   -jf
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
