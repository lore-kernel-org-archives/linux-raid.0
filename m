From: David Brown <david@westcontrol.com>
Subject: Re: Software RAID and TRIM
Date: Wed, 29 Jun 2011 14:42:12 +0200
Message-ID: <iuf6me$9us$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com> <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106291133060.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/06/2011 12:33, Tom De Mulder wrote:
> On 28/06/11, David Brown wrote:
>
>> However, AFAIUI, you are wrong about TRIM being essential for the
>> continued high performance of SSDs. As long as your SSDs have some
>> over-provisioning (or you only partition something like 90% of the
>> drive), and it's got good garbage collection, then TRIM will have
>> minimal effect.
>
> While you are mostly correct, over time even consumer SSDs will end up
> in this state.
>

I don't quite follow you here - what state will consumer SSDs end up in?

> Maybe I should have specified--my particular aim is to try and use
> (fairly high-end) consumer SSDs for "enterprise" server applications,
> hence the research into RAID. Most hardware RAID controllers that I know
> of don't pass on the TRIM command (for various reasons), so I was hoping
> to have more luck with software RAID.
>
>

Now you know /why/ hardware RAID controllers don't implement TRIM!


Have you tried any real-world benchmarking with realistic loads with a 
single SSD, ext4, and TRIM on and off?  Almost every article I've seen 
on the subject is using very synthetic benchmarks, almost always on 
windows, few are done with current garbage-collecting SSDs.  It seems to 
be accepted wisdom from the early days of SSDs that TRIM makes a big 
difference - and few people challenge that with real numbers or real 
thought, even though the internal structure of the flash has changed 
dramatically (transparent compression, for example, gives a completely 
different effect).

Of course, if you /do/ try it yourself and can show clear figures, then 
I'm willing to change my mind :-)  If I had a spare SSD, I'd do the 
testing myself.



