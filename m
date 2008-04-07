From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: How to rename MD device (e.g. md3 -> md2)?
Date: Mon, 7 Apr 2008 14:51:32 -0700
Message-ID: <e9c3a7c20804071451m7cbd10bam5d66a24191cf2958@mail.gmail.com>
References: <87zls53bv1.fsf@magla.zg.iskon.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zls53bv1.fsf@magla.zg.iskon.hr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Zlatko Calusic <zlatko.calusic@iskon.hr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 7, 2008 at 8:48 AM, Zlatko Calusic <zlatko.calusic@iskon.hr> wrote:
> Hello list!
>
>  Does anybody know what would be the fastest way to rename MD device
>  (without recreating/resyncing)? I have md0, md1 and md3 in system (don't
>  ask :)), and obviously it would look slightly nicer if that md3 was
>  called md2 instead, like I have on other machines (with all the same
>  setup, except this small difference). Is it possible?
>

Sure, you should just be able to do:

mdadm --stop /dev/md3
mdadm --assemble /dev/md2 <insert component devices here>

--
Dan
