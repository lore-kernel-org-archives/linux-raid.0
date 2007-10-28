From: Luca Berra <bluca@comedia.it>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sun, 28 Oct 2007 14:46:40 +0100
Message-ID: <20071028134636.GB22861@percy.comedia.it>
References: <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org> <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com> <20071020075349.GA17431@teal.hq.k1024.org> <1192885917.1666.112.camel@firewall.xsintricity.com> <20071026095417.GC32550@percy.comedia.it> <1193424779.10336.287.camel@firewall.xsintricity.com> <20071027080035.GC12053@percy.comedia.it> <1193515743.10336.324.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193515743.10336.324.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 27, 2007 at 04:09:03PM -0400, Doug Ledford wrote:
>On Sat, 2007-10-27 at 10:00 +0200, Luca Berra wrote:
>> On Fri, Oct 26, 2007 at 02:52:59PM -0400, Doug Ledford wrote:
>> >On Fri, 2007-10-26 at 11:54 +0200, Luca Berra wrote:
>> >> On Sat, Oct 20, 2007 at 09:11:57AM -0400, Doug Ledford wrote:
>> >> just apply some rules, so if you find a partition table _AND_ an md
>> >> superblock at the end, read both and you can tell if it is an md on a
>> >> partition or a partitioned md raid1 device.
>> >
>> >In fact, no you can't.  I know, because I've created a device that had
>> >both but wasn't a raid device.  And it's matching partner still existed
>> >too.  What you are talking about would have misrecognized this
>> >situation, guaranteed.
>> then just ignore the device and log a warning, instead of doing a random
>> choice.
>> L.
>
>It also happened to be my OS drive pair.  Ignoring it would have
>rendered the machine unusable.

I wonder what would have happened if it got it wrong

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
