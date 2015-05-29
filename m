From: XiaoNi <xni@redhat.com>
Subject: Re: raid5 reshape is stuck
Date: Fri, 29 May 2015 20:19:58 +0800
Message-ID: <5568596E.1090505@redhat.com>
References: <1612858661.15347659.1431671671467.JavaMail.zimbra@redhat.com>	<427651758.4121803.1432637303447.JavaMail.zimbra@redhat.com>	<20150527100253.221ab553@notabene.brown>	<20150527111004.5f136f23@notabene.brown>	<2129908770.5092770.1432726084717.JavaMail.zimbra@redhat.com>	<20150527213449.6e017deb@notabene.brown>	<476656362.5105083.1432728264276.JavaMail.zimbra@redhat.com>	<20150528085958.0f95e323@notabene.brown>	<45685228.5717919.1432794771906.JavaMail.zimbra@redhat.com>	<20150528164923.2cd4af02@notabene.brown>	<556849E2.7030405@redhat.com> <20150529211947.3271b204@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150529211947.3271b204@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/29/2015 07:19 PM, NeilBrown wrote:
> On Fri, 29 May 2015 19:13:38 +0800 XiaoNi <xni@redhat.com> wrote:
>
>
>> And it's really the problem about selinux. The patch works after the
>> command "setenforce 0". It need the patch you gave.  Is it right
>> to setenforce 0 every time? I'll read the doc about selinux.
> I know nothing about selinux, and don't really want to.
> Presumably selinux needs to be told that mdadm, when run from systemd, can
> access all block devices.
> If there is something I can add to the system unit file to make this happen
> I am happy to, but I would need someone to tell me what.
>
> Glad you are making progress and learning a lot!!
>
> NeilBrown

But it really need the patch you gave several days before. I already 
tried without the patch, reshape can be
stuck even selinux is set to Permissive.

And it's a problem with systemd and selinux too. If I run mdadm --grow 
--continue /dev/md0, the reshape can start.
If I run systemctl start mdadm-grow-continue@md0.service, it can't 
start. I'll look for the answer.

Best Regards
Xiao

