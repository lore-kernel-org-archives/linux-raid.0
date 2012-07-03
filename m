From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Resync Every Sunday
Date: Mon, 02 Jul 2012 20:33:59 -0700
Message-ID: <7q5ac9xsrb.ln2@goaway.wombat.san-francisco.ca.us>
References: <4FF0328B.5080103@abpni.co.uk>
 <58p6c9xfag.ln2@goaway.wombat.san-francisco.ca.us>
 <4FF0B6B2.1080808@abpni.co.uk> <4FF0BFF9.4020207@nuclearwinter.com>
 <4FF0C7C0.7020706@abpni.co.uk> <4FF0C8AF.9020703@abpni.co.uk>
 <4FF1D512.8030406@nuclearwinter.com>
 <0hg9c9xno4.ln2@goaway.wombat.san-francisco.ca.us>
 <4FF226FD.5000300@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-07-02, Jonathan Tripathy <jonnyt@abpni.co.uk> wrote:
>
> Unfortunately it is not possible for me to upgrade. Would just simply 
> replacing the raid-check script work? Or is that dangerous?

It's ''probably'' safe.  You could download the script and diff it
against your existing one to see what the differences actually are; that
might help you decide how safe it is.

In the short run, all that script really does is issue "check" requests
to each array.  The rest is mostly window dressing and silly admin
tricks (e.g., checking mismatch_cnt and emitting on stdout if it's
nonzero; the default is not to print output, so there's no email unless
an array has mismatches).

--keith

-- 
kkeller@wombat.san-francisco.ca.us


