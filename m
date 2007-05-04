From: Ruslan Sivak <rsivak@istandfor.com>
Subject: Re: raid10 on centos 5
Date: Fri, 04 May 2007 19:51:08 -0400
Message-ID: <463BC6EC.1070800@istandfor.com>
References: <200705042313.l44NDL712377@www.watkins-home.com> <463BBFFF.70000@istandfor.com> <463BC1E2.6090301@ilm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463BC1E2.6090301@ilm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Stair <estair@ilm.com>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eli Stair wrote:
>
> You shouldn't need to build a new kernel, just extract the SRPM for 
> the initial install (CentOS 5, no updated kernels), use the config for 
> the appropriate kernel (SMP, UP, i386/x86_64), enable the raid10 
> module and do a 'make modules'.  You may need to do a minor amount of 
> tweaking in the installer image to include this, but nothing serious.  
> Alternately, just building a driver disk with the module and source it 
> in the install.  Interesting that it's not enabled in the installer 
> image, because it's present in a fully-booted system... space 
> limitations?
>
>
> /eli
>
It is not present in a fully booted system for me either.  Are you 
running centos 5? 

How would I make a driver disk?  I'm not very familiar with this. 

Russ


