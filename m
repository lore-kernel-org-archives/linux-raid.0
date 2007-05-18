From: Andrew Burgess <aab@cichlid.com>
Subject: Re: unreadable drives can be synchronized?
Date: Fri, 18 May 2007 07:47:24 -0700
Message-ID: <200705181447.l4IElO2a000640@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: colin.p.mccabe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Basically, B appears to be "write-only"; it will never return an error on a
>write, but just try to read from it, and you will be sorry.

It would be interesting to see what SMART says about drive B, especially
the short and long self tests.

