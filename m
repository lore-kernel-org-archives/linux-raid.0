From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Resync Every Sunday
Date: Sun, 01 Jul 2012 13:41:09 -0700
Message-ID: <58p6c9xfag.ln2@goaway.wombat.san-francisco.ca.us>
References: <4FF0328B.5080103@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-07-01, Jonathan Tripathy <jonnyt@abpni.co.uk> wrote:
>
> What's going on? Am I missing something here? Is data on the arrays at 
> risk? We're using CentOS 5 with mdadm v2.6.9. Kernel version is 
> 2.6.18-274.18.1.el5

As you are running CentOS, check /etc/sysconfig/raid-check.  Someone may
have configured certain arrays not to be checked.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


