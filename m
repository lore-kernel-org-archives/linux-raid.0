From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 17:34:24 +0100
Message-ID: <200501101734.24851.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501081749.32816.maarten@ultratux.net> <200501082001.09317.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501082001.09317.maarten@ultratux.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 January 2005 20:01, maarten wrote:
> On Saturday 08 January 2005 17:49, maarten wrote:
> > On Saturday 08 January 2005 15:52, Frank van Maarseveen wrote:
> > > On Fri, Jan 07, 2005 at 04:57:35PM -0500, Guy wrote:

> As the system is now online again, busy copying, I can show the exact
> config:
>

Well all about the array is done and working fine up to now.  Except one thing 
that I didn't anticipate: The application that's supposed to run has some 
problems under -I suppose- the new 2.4.28 kernel. I've had two panics / 
oopses in syslog already, and the process then is unkillable, so a reboot is 
in order.   But I think that's bttv related, not the I/O layer.
In any case I suffered through two lengthy raid resyncs already... ;-|

So I've been shopping around for a *big* servercase today so I can put all 
disks (these 5, plus 6 from the current fileserver) in one big tower. I'll 
then use that over NFS and can revert back to my older working kernel.

I've chosen a Chieftec case, as can be seen here 
http://www.chieftec.com/products/Workcolor/CA-01.htm
and here in detail
http://www.chieftec.com/products/Workcolor/NewBA.htm
Nice drive cages, eh ? :-)

P.S.:  I get this filling up my logs. Should I be worried about that ?
Jan 10 11:30:32 dozer kernel: raid5: switching cache buffer size, 512 --> 4096
Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 4096 --> 512
Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 512 --> 4096
Jan 10 11:30:36 dozer kernel: raid5: switching cache buffer size, 4096 --> 512

Maarten

