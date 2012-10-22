From: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Subject: Re[2]: 4x3TB raid5 - no autodetect
Date: Mon, 22 Oct 2012 17:56:00 +0200
Message-ID: <123699751.20121022175600@oudeis.org>
References: <441614417.20121022155507@oudeis.org>
 <508553FF.6020302@anonymous.org.uk>
Reply-To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508553FF.6020302@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


JR> In-kernel auto-assembly is only supported for metadata 0.90, and even 
JR> then the feature is deprecated. If you have your root filesystem on a md 
JR> array, use an initrd with mdadm in it to start it.

if I understand it correctly, metadata 0.90 is not supporting drives >
2TB?

will in-kernel auto-assembly be supported sometimes in the future?
this was quite a useful feature.

tnx & cu

------------------------------------------------------------------------------
Unix gives you just enough rope to hang yourself -- and then a couple of more 
feet, just to be sure.
(Eric Allman)
------------------------------------------------------------------------------

