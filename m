From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Journalling filesystem corruption fixed in between?
Date: Tue, 2 Oct 2007 07:12:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710020712350.24938@p34.internal.lan>
References: <735D322AED9CD711BE53000476917CD0029728C3@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <735D322AED9CD711BE53000476917CD0029728C3@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Tue, 2 Oct 2007, Rustedt, Florian wrote:

> Hello list,
>
> some folks reported severe filesystem-crashes with ext3 and reiserfs on
> mdraid level 1 and 5.
>
> Is this safe now? Or should i only use non-journalling-filesystems on
> software-raid-devices?
>
> Kind regards, Florian Rustedt
> **********************************************************************************************
> IMPORTANT: The contents of this email and any attachments are confidential. They are intended for the
> named recipient(s) only.
> If you have received this email in error, please notify the system manager or the sender immediately and do
> not disclose the contents to anyone or make copies thereof.
> *** eSafe scanned this email for viruses, vandals, and malicious content. ***
> **********************************************************************************************
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I use RAID1 (ext3) for /boot and RAID1 (XFS) for / -- no issues.

Justin.
