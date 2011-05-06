From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: mdadm raid1 read performance
Date: Fri, 6 May 2011 15:44:31 -0500
Message-ID: <09.95.16951.AAD54CD4@cdptpa-omtalb.mail.rr.com>
References: <4DC0A478.9010704@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC0A478.9010704@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'John Robinson' <john.robinson@anonymous.org.uk>, 'Liam Kurmos' <quantum.leaf@gmail.com>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of John Robinson
> Sent: Tuesday, May 03, 2011 7:57 PM
> To: Liam Kurmos
> Cc: Linux RAID
> Subject: Re: mdadm raid1 read performance
> 
> On 04/05/2011 01:07, Liam Kurmos wrote:
> > Hi,
> >
> > I've been testing mdadm (great piece of software btw) however all my
> > test show that reading from raid1 is only the same speed as reading
> > from a single drive.
> >
> > Is this a known issue? or is there something seriously wrong with my
> > system? i have tried v2.8.1 and v.3.2.1 without difference and several
> > benchmarking methods.
> 
> This is a FAQ. Yes, this is known. No, it's not an issue, it's by design
> - pretty much any RAID 1 implementation will be the same because of the
> nature of spinning discs. md RAID 1 will serve multiple simultaneous
> reads from the different mirrors, giving a higher total throughput, but
> a single-threaded read will read from only one. If you want RAID 0
> sequential speed at the same time as RAID 1 mirroring, look at md RAID
> 10, and in particular RAID 10,f2; please see the excellent documentation
> and wiki for more details.

	I would go so far as to say it is more than just by design.  It is
by the very fundamental nature of RAID1.  RAID1 is intended to be a simple
mirror.  Every write is sent in identical form to precisely the same logical
sector of all devices.  Any read can come from any device in the array.  The
WriteMostly specifier can help insure the best throughput in the case where
one of the members is inherently slower than the other members of the array,
and some RAID1 implementations support load balancing, but otherwise there
are no real operational gains in performance for a RAID1 array over a single
disk.

