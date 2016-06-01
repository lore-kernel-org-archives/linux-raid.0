From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: raid 5 crashed
Date: Wed, 1 Jun 2016 09:48:35 +0800
Message-ID: <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <574DDCBD.40801@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 01/06/16 02:49, Wols Lists wrote:

> When the new drives arrive, copy each old drive in turn onto a new drive...
>
> dd if=/dev/sda of=/dev/sde
>
> etc etc. Expect it to take a little while ... (others may chime in and
> tell you to use ddrescue rather than dd - I don't know which one is
> best, both should work).

Do NOT use dd on a drive with bad sectors.... ever....

Using dd like you prescribe above will simply abort when it hits the 
first read error. Using dd with the 'noerror' option will appear to work 
and make you feel all warm and fuzzy, until you eventually realize that 
when it encounters a read error, it skips that input block but does 
*not* pad the output appropriately. So you wind up with everything after 
the first read error in the wrong place on the disk. That will never end 
well.

Use one of the ddrescue style of applications to guarantee everything 
comes out where it needs to be regardless of input read errors.

Now, having said that :

Much better to try and get the array running in a read-only state with 
all disks in place and clone the data from the array rather than the 
disks after they've been ddrescued. In the case of a running array, a 
read error on one of the array members will see the RAID attempt to get 
the data from elsewhere (a reconstruction), whereas a read from a disc 
cloned with ddrescue will happily just report what was a faulty sector 
as a big pile of zeros, and *poof* your data is gone.

Set the timeouts appropriately (and conservatively) to give the disks 
time to actually report they can't read the sector. This will allow md 
to try and get it elsewhere rather than kicking the disc out because the 
storage stack timed it out as faulty.

Brad.

