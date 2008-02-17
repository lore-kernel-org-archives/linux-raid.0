From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: RAID5 to RAID6 reshape?
Date: Sun, 17 Feb 2008 15:06:53 +0100
Message-ID: <20080217150653.567bab75@szpak>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Beolach said:     (by the date of Sat, 16 Feb 2008 20:58:07 -0700)


> Or would I be better off starting w/ 4 drives in RAID6?

oh, right - Sevrin Robstad has a good idea to solve your problem -
create raid6 with one missing member. And add this member, when you
have it, next year or such.

-- 
Janek Kozicki                                                         |
