From: Tim Small <tim@buttersideup.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Wed, 21 Apr 2010 19:40:19 +0100
Message-ID: <4BCF4693.3020101@buttersideup.com>
References: <4BAB8D41.4010801@gmail.com>	 <F50E50EC-32CF-4FC4-949B-E8DA56B08D50@santools.com>	 <4BABA12D.6040605@shiftmail.org> <4BAF8185.9040307@gmx.net>	 <4BC61D47.6090403@tmr.com> <4BCC65EB.3080803@cfl.rr.com>	 <4BCEFB99.9080806@tmr.com> <4BCF163C.6040604@cfl.rr.com> <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Bill Davidsen <davidsen@tmr.com>, st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Knecht wrote:
> This machine only gets a few hours of use a day but is generally
> powered up all the time. I don't know why Linux wakes this drive up
> roughly every two minutes, assuming it's Linux and not the drive
> itself or something on the motherboard, but it does.
>   


This is documented here:

https://ata.wiki.kernel.org/index.php/Known_issues#Drives_which_perform_frequent_head_unloads_under_Linux

If you want to fix it, then wdidle3.exe worked for me.  Search for:

wdidle3_1_00.zip


Tim.
