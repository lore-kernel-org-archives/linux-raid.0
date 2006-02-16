From: Luca Berra <bluca@comedia.it>
Subject: Re: 2+ raid sets, sata and a missing hd question
Date: Thu, 16 Feb 2006 09:24:44 +0100
Message-ID: <20060216082443.GB17311@percy.comedia.it>
References: <20060215065028.GA2452@percy.comedia.it> <Pine.LNX.4.44.0602151842550.6126-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0602151842550.6126-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 15, 2006 at 06:44:29PM -0500, Mark Hahn wrote:
>> hint
>> echo DEVICE partitions >> /etc/mdadm.conf
>> mdadm -Esc partitions | grep ARRAY>> /etc/mdadm.conf
>> 
>> >All md partitions are of type fd (Linux raid autodetect).
>> >
>> this is surprisingly not at all relevant
>
>I'm not sure about that.  I've accidentally shuffled disks before,
>and 0xfd resulted in all the MD's coming to life again.  I never 
>use /etc/mdadm.conf, since there doesn't seem to be much point...

i did not speak about in-kernel autodetection.

don't cc me on list replies unless it is really important

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
