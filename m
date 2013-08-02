From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RFC swap over raid1
Date: Fri, 02 Aug 2013 09:59:16 +0800
Message-ID: <51FB1274.3000302@fnarfbargle.com>
References: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFoNKgHErujKuCLMvx_qbDa2dwhW+sMD=7W9W0hHTWB-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/08/13 06:11, Roberto Spadim wrote:
> hi guys, should i use raid1 with swap partitions? why?

> what's the advantages and disvantages?


In parallel to Doug's comments. A few years ago, I spent literally 
*days* trying to figure out why random processes were dying on one of my 
servers. It turned out there was a bad block in the swap partition (this 
was pre-SMART). Ever since then, if I've used swap on a machine that was 
important enough, I used RAID-1.


