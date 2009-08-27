From: Have Blue <airsoldierproducts@gmail.com>
Subject: Minor typo in ReadMe.c
Date: Thu, 27 Aug 2009 15:05:11 -0500
Message-ID: <4A96E6F7.904@airsoldier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This confused me a bit at first, as I was cut-n-pasting the example from 
the help text...

Line 319 in ReadMe.c is currently:
"Usage:  mdadm --create device -chunk=X --level=Y --raid-devices=Z 
devices\n"

Should have another hyphen before the chunk option.

- Michael
