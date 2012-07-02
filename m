From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Resync Every Sunday
Date: Mon, 02 Jul 2012 14:30:40 -0700
Message-ID: <0hg9c9xno4.ln2@goaway.wombat.san-francisco.ca.us>
References: <4FF0328B.5080103@abpni.co.uk>
 <58p6c9xfag.ln2@goaway.wombat.san-francisco.ca.us>
 <4FF0B6B2.1080808@abpni.co.uk> <4FF0BFF9.4020207@nuclearwinter.com>
 <4FF0C7C0.7020706@abpni.co.uk> <4FF0C8AF.9020703@abpni.co.uk>
 <4FF1D512.8030406@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-07-02, Larkin Lowrey <llowrey@nuclearwinter.com> wrote:
> That is not the correct logic so your script is out of date. I would
> recommend updating your mdadm package via yum. My CentOS 6.2 install has
> the correct logic in /usr/sbin/raid-check, which is the new location for
> the script. The RPM I have installed is mdadm-3.2.2-9.el6.x86_64.

The OP is on CentOS 5, where the latest package is 2.6.9-3.  I am not
sure whether that version has the bug fix.

--keith

-- 
kkeller@wombat.san-francisco.ca.us


