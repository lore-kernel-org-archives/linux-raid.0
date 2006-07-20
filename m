From: "Pieter Steyn" <pieterste@gmail.com>
Subject: Megaraid, howto?
Date: Thu, 20 Jul 2006 09:14:27 +0200
Message-ID: <c49e66200607200014wbefb21ay4d9a24ccd43356b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

I have a few hosts that use Megaraid controllers.

Could someone please show me an effective way to monitor the status?

I've used the software on dells website, and the only program partly
useful was Megamon, which is a gui menu based program that runs on the
shell, I've written an expect script that gives me the proper output
when I run the program on that shell, but it does not work from within
crontab / ssh hostname "command".

If anyone could please tell me of either an alternative way / or how I
can get my expect script to work through crontab, I'd greatly
apreciate it!

Thanks alot,
Pieter Steyn.
