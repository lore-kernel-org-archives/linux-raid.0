From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: I've made a bit of a mess in my raid setup
Date: Sat, 08 Mar 2014 12:05:11 +0100
Message-ID: <531AF967.60500@grumpydevil.homelinux.org>
References: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFRU1XuCKyfL7uMa0wJj0dUjHyhBDp933_O4+TsQk33KM6brUA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Federico Foschini <undicizeri@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08-03-14 11:33, Federico Foschini wrote:
>
> Why sda1 and sdb1 are market as boot? My boot disk is sdc. Also grub is
> installed in sdc AND in sda I think that's an error right?
>
> Why sda and sdb have partitions while sdd doesn't?
I'd see you re-used disks you already had, and did not delete the 
partitions on them when you re-used them in the raid

Is there something wrong with my setup?

Do you have any reason to think so?
>
Cheers

Rudy
