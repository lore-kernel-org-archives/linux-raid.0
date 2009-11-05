From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Data corruption after raid migration (raid5 to raid6 in 2.6.31
	with mdadm 3.1)
Date: Thu, 5 Nov 2009 08:51:25 -0800
Message-ID: <4877c76c0911050851y48da6e5did5d8fb39e8aad90b@mail.gmail.com>
References: <788014650911050154x1861b292i3ab221a9dec7adb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <788014650911050154x1861b292i3ab221a9dec7adb0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: khchen@synology.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My copy of mdadm 3.1 didn't want me to reshape to raid6 without using
linux-2.6.32 or later (I used the latest RC: 2.6.32-rc5-git5).
