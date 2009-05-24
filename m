From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: LVM->RAID->LVM
Date: Sun, 24 May 2009 21:46:42 +0200
Message-ID: <4A19A422.3000204@rabbit.us>
References: <a43edf1b0905241131t7dcb3d85v98597f061a4345d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a43edf1b0905241131t7dcb3d85v98597f061a4345d6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Billy Crook wrote:
> <snip> 
> I do wish there was an 'mdadm --block-until-all-healthy' that you
> could use in scripts to block script execution until there were no
> current or DELAYED resyncs or reshapes.

You mean mdadm -W ?
