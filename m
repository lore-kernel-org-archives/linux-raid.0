From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Tue, 5 Nov 2013 13:32:07 +0200
Message-ID: <A30C811A-B2E9-4A46-A8D6-26E64C0D090E@gmail.com>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5278C2A6.7060005@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I checked out mdadm man page, read some pages on the web, and well, what bitmap chunk size should I go for considering these are WD Elements 2TB drives (what kind of technical information about these drives are relevant when considering a bitmap chunk size?)

Ivan

On Nov 5, 2013, at 12:04 PM, Adam Goryachev <mailinglists@websitemanagers.com.au> wrote:

> Personally, I would also do:
> mdadm --grow /dev/md0 --bitmap=internal
> This means next time you have a similar issue, when you add the older
> drive, it will only sync the small parts of the drive that are out of
> date, instead of the entire drive.

