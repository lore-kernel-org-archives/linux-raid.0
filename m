From: David Greaves <david@dgreaves.com>
Subject: Re: raid10 on centos 5
Date: Fri, 04 May 2007 23:03:10 +0100
Message-ID: <463BAD9E.2040900@dgreaves.com>
References: <463B5DB3.6020502@istandfor.com> <CE7B1A4EF22E704CBFFD9A35BA5C82221E00D2@ausx3mpc110.aus.amer.dell.com> <463B6536.1010505@istandfor.com> <Pine.LNX.4.64.0705041323330.9571@p34.internal.lan> <463B6D22.3040202@istandfor.com> <Pine.LNX.4.64.0705041356570.10003@p34.internal.lan> <463B74D2.7020308@istandfor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463B74D2.7020308@istandfor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ruslan Sivak <rsivak@istandfor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ruslan Sivak wrote:
> So a custom kernel is needed?  Is there a way to do a kickstart install
> with the new kernel?  Or better yet, put it on the install cd?

have you tried:
 modprobe raid10

?

David
