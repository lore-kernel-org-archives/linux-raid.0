From: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Subject: Re: ITE IT 8212 problem
Date: Sun, 09 Nov 2003 18:28:43 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.2.0.9.0.20031109182651.0669be90@mailhost.ivimey.org>
References: <1068386274.3fae47e2ca3c3@www.stud.u-szeged.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1068386274.3fae47e2ca3c3@www.stud.u-szeged.hu>
To: Monda.Laszlo@stud.u-szeged.hu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 13:57 09/11/2003, Monda.Laszlo@stud.u-szeged.hu wrote:
>./iteraid:o: unresolved symbol prefetch

The ITE driver was written for a kernel that differs in some way from the 
kernel you are using it with. You must either (a) change kernel version (b) 
change the ITE source or (c) change the kernel source. Which you do depends 
on the version you are using, your skills, etc

HTH

Ruth


