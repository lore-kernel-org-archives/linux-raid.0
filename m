From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: Spontaneous rebuild
Date: Sun, 2 Dec 2007 22:16:11 +0100
Message-ID: <20071202221611.3cecf900@absurd>
References: <475230AF.3010100@student.tuwien.ac.at>
	<Pine.LNX.4.64.0712020445160.30169@p34.internal.lan>
	<4752AE15.7000301@student.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4752AE15.7000301@student.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Justin Piszcz schrieb:
> >
> > Naturally, when it is reset, the device is disconnected and then
> > re-appears, when MD see's this it rebuilds the array.

Least you can do is to add an internal bitmap to your raid, this will
make rebuilds faster.... :-/

-- 
Janek Kozicki                                                         |
