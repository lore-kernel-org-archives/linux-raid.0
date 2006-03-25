From: Luca Berra <bluca@comedia.it>
Subject: Re: raid1+raid0 mdadm
Date: Sat, 25 Mar 2006 19:26:50 +0100
Message-ID: <20060325182649.GF14018@percy.comedia.it>
References: <44203782.2000505@gmail.com> <20060321180050.GC27173@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060321180050.GC27173@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 21, 2006 at 07:00:50PM +0100, Andre Noll wrote:
>On 18:27, Dariusz Malec wrote:
>
>> I can't configure mdadm. I have created 2 raid1 devices and i wanted to 
>> connect  them with raid0. Everything is fine when i use command line, 
>> but after reboot mdadm starts only raid1 devices.
>
>Are you using udev?
>
>IIRC, there was an issue with stacked md devices like yours. Your
>problem might be that the device node for the final raid0 is missing.
>
mdadm --auto=yes creates device files for you.

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
