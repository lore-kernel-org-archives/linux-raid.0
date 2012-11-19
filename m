From: Phil Turmel <philip@turmel.org>
Subject: Re: Issue with Raid 10 super block failing
Date: Mon, 19 Nov 2012 15:47:46 -0500
Message-ID: <50AA9AF2.3070501@turmel.org>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com> <50A82267.9030802@turmel.org> <CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com> <50A8F247.8060002@turmel.org> <CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com> <50A91487.70806@turmel.org> <CAPAnFc9KLBDhCDt1WYiOye5wvRv=zvBDfL1=8OEYg04VBCLHBQ@mail.gmail.com> <50A92F53.5080100@turmel.org> <CAPAnFc_siNMWcYtYf56dYO1LgkCKPxMDhC-PuMD-18D4jNJcqw@mail.gmail.com> <50AA36AD.4080100@turmel.org> <CAPAnFc-FyxxBviLmT8qUWD-zT-ONER-5zQwj7wPnvkpawFa87g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPAnFc-FyxxBviLmT8qUWD-zT-ONER-5zQwj7wPnvkpawFa87g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew Reusser <dreusser@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/19/2012 03:41 PM, Drew Reusser wrote:
> 
> Looking at this from all angles, is there a way to look at the
> individual disks (like sdb and sde) and build a raid 0 from them and
> see if that works?   Is there a way to see which if any are bad from a
> file system point of view and exclude it and try to rebuild it?  I am
> just grasping at straws trying to figure out which way to go.

The effort to examine the drives to figure out how they would go
together in a raid 0 is the same effort to figure out how they go
together in the original raid 10,n2.  So, no.

But look again at my e-mail from earlier today for scanning the
individual drives.  Please also answer whether you used '--assume-clean'
each time you recreated the array.

Phil

