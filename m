From: Francois Barre <francois.barre@gmail.com>
Subject: Re: help: How to compile md source code as modules? Thanks!
Date: Tue, 17 Jan 2006 10:49:30 +0100
Message-ID: <fd8d0180601170149x71db7a5v@mail.gmail.com>
References: <200601171629140629275@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601171629140629275@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Zhikun Wang <raidwang@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2006/1/17, Zhikun Wang <raidwang@gmail.com>:
> hi,
>        I am a new guy in linux MD. I want to add some fuctions into md source code to do research. But i can not complile MD source code as modules properly. Every time i need to put the source code at the directory and bulid the whole kernel. This is a terrible thing for me. So i wonder whether you can tell me how compile md as modules?
>        Thank you very much!
> zkwang
>

Hello,

First of all, you have to set md as a module.
In /usrc/src/linux, run make menuconfig, and configure md driver to be
compiled as a module [M].
Then, I think you have two options here :
- If you really want to build md (or any module) in a separate
directory, you will have to play with the kernel Makefile params, such
as SUBDIR and MODVERDIR. Have a look on out-of-kernel drivers, such as
madwifi, which uses these kind of building [http://madwifi.org/].
- Modify md source in-place, in /usr/src/kernel/drivers/md, and build
up as modules here. It seems to me like you're modifying code out of
the tree, and inserting after.
BTW, how do you compile your kernel ? Do you have any kind of
distro-specific way to build it ?
Maybe a simple make modules && make modules_install (from
/usr/src/linux) would be enough to achieve what you want to do...
