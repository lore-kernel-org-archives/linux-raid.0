From: Al Boldi <a1426z-u1xxEuL7cY4AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent
	Filesystems
Date: Wed, 13 Dec 2006 22:57:24 +0300
Message-ID: <200612132257.24399.a1426z@gawab.com>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Return-path: <unionfs-bounces-K1gu+h1r3dsZjdeEBZXbMidm6ipF23ct@public.gmane.org>
In-Reply-To: <Pine.GSO.4.53.0612122217360.22195@compserv1>
Content-Disposition: inline
List-Unsubscribe: <http://www.fsl.cs.sunysb.edu/mailman/listinfo/unionfs>,
	<mailto:unionfs-request-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.fsl.cs.sunysb.edu/pipermail/unionfs>
List-Post: <mailto:unionfs-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org>
List-Help: <mailto:unionfs-request-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org?subject=help>
List-Subscribe: <http://www.fsl.cs.sunysb.edu/mailman/listinfo/unionfs>,
	<mailto:unionfs-request-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org?subject=subscribe>
Sender: unionfs-bounces-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org
Errors-To: unionfs-bounces-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org
To: Nikolai Joukov <kolya-EX0cT3Az47bauI2f2gSDlQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fistgen-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, unionfs-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org
List-Id: linux-raid.ids

Nikolai Joukov wrote:
> We have designed a new stackable file system that we called RAIF:
> Redundant Array of Independent Filesystems.

Great!

> We have performed some benchmarking on a 3GHz PC with 2GB of RAM and U320
> SCSI disks.  Compared to the Linux RAID driver, RAIF has overheads of
> about 20-25% under the Postmark v1.5 benchmark in case of striping and
> replication.  In case of RAID4 and RAID5-like configurations, RAIF
> performed about two times *better* than software RAID and even better than
> an Adaptec 2120S RAID5 controller.

I am not surprised.  RAID 4/5/6 performance is highly sensitive to the 
underlying hw, and thus needs a fair amount of fine tuning.

> This is because RAIF is located above
> file system caches and can cache parity as normal data when needed.  We
> have more performance details in a technical report, if anyone is
> interested.

Definitely interested.  Can you give a link?


Thanks!

--
Al
