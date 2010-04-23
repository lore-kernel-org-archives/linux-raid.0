From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 22 Apr 2010 23:44:27 -0400
Message-ID: <1271994267.2855.22.camel@faldara>
References: <4BAB8D41.4010801@gmail.com>
	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
	 <4BCF4693.3020101@buttersideup.com>
	 <201004221913.50692.eye.of.the.8eholder@gmail.com>
	 <4BD0A716.4080909@cfl.rr.com>
	 <z2y5bdc1c8b1004221623l3d83165ek3e605d74132a2de3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <z2y5bdc1c8b1004221623l3d83165ek3e605d74132a2de3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2010-04-22 at 16:23 -0700, Mark Knecht wrote:
> Validated doesn't mean spec'ed, right? So they spec it at 300K but
> they test and find that some units go to 1M, so they report that some
> units go to 1M but they keep the spec at 300K. We feel more
> comfortable with the operation but if the drive fails at 400K then
> they are within their rights to say the drive lived a useful life and
> replace or not replace it as they see fit.

Specifications are based on validation; they don't have anything to do
with the warranty.  If one drive made it to a million, who cares?  The
question is will the majority of them?  Just because one drive made it
to a million hours before failing does not mean a million hours is the
MTBF, nor does a drive failing at half MTBF have anything to do with
whether it is still under warranty or not.  The warranty is expressed in
real time duration, not hours of operation or head unload count.

The question is, if you have a dozen drives in a raid array, is there a
good chance that none will fail after they hit 300,000 unloads.  If the
answer to that is no, and it looks like they will reach 300,000 unloads
in a few months, then you probably don't want to use those drives.

> Keep in mind that just because we possibly solve the load cycle count
> problem doesn't mean that the drive will work for RAID. WD has also
> stated that these drives don't have any TLER features.

TLER sounds like marketing department BS to me.  ANY drive should be
able to retry a read plenty of times and give up in less than 7 seconds
without some special feature.  I've never used a drive with this
"feature" and never had mdadm kick a drive offline just because it
developed a bad sector.  Usually I notice from a smart check and force a
write to the sector and the drive remaps it.


