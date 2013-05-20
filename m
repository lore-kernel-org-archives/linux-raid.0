From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Resync raid array problem
Date: Sun, 19 May 2013 19:53:59 -0700
Message-ID: <7rfo6axs9j.ln2@goaway.wombat.san-francisco.ca.us>
References: <loom.20130520T035627-78@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-05-20, Tarak <tarakramgopal@gmail.com> wrote:
> We sucessfully created a Raid array of 8 harddisks.
> On power failure situation,

You should probably have some sort of redundant power for such an
array--either a UPS or backup power provided by a building generator.

> the resync of raid array 
> is taking too much of time almost equal to 
> the time taken for creating the raid array of hard disks.

IIRC, a RAID5 is created by making the array in degraded mode and
resyncing the array.  So "create" and "resync" are basically equal in
duration in this scenario.  (I think creating a RAID6 works differently,
but it's possible that create and resync times are comparable as well.)

--keith


-- 
kkeller@wombat.san-francisco.ca.us


