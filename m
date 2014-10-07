From: Errol Neal <eneal@businessgrade.com>
Subject: Re: auto assemble in read-only mode?
Date: Tue, 7 Oct 2014 02:56:31 -0400
Message-ID: <1412664991898536500@businessgrade.com>
References: <1412600795583058500@businessgrade.com>
Reply-To: eneal@businessgrade.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1412600795583058500@businessgrade.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: eneal@businessgrade.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 10/06/2014 09:06 AM, Errol Neal <eneal@businessgrade.com> wrote:
> hi folks. is it possible to assemble an md device in read-only mode? 
> after an array has been assembled, I know I can mark it as readonly with --misc -o /dev/md0 for example, but only after its been assembled it seems..
> 

Hi again. No thoughts here? 
I'm need to run a RAID1 device on two independent nodes (shared storage) and I'd like to assemble the device on the "slave" node in read-only mode to prevent any sync actions and etc. 
