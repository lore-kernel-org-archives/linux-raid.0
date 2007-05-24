From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Fwd: Identify SATA Disks
Date: Thu, 24 May 2007 18:19:47 +0200
Message-ID: <4655BB23.7000101@wpkg.org>
References: <8c4e120705230023v71a2ffa3p182f1e02ccb9cd54@mail.gmail.com> <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8c4e120705231629q727718f2yb0704ff33b7012c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: lewis shobbrook <lewis@blue-matrix.org>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

lewis shobbrook schrieb:
> Hi All,
> I'm wondering if anyone has discovered any nice tricks to assist in
> identification of hdd devices.
> I have an 8 bay hotswap array, pretty lights and have been wondering
> what others out there might be doing to determine which disk in an
> array is which.

Considering you can see HDD LEDs blinking, something like:

dd if=/dev/sdb of=/dev/null


should help you identify the disk :)


-- 
Tomasz Chmielewski
http://wpkg.org
