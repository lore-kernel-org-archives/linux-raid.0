From: Ruslan Sivak <rsivak@istandfor.com>
Subject: Re: raid10 on centos 5
Date: Fri, 04 May 2007 12:54:14 -0400
Message-ID: <463B6536.1010505@istandfor.com>
References: <463B5DB3.6020502@istandfor.com> <CE7B1A4EF22E704CBFFD9A35BA5C82221E00D2@ausx3mpc110.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CE7B1A4EF22E704CBFFD9A35BA5C82221E00D2@ausx3mpc110.aus.amer.dell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrick_Boyd@Dell.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Patrick_Boyd@Dell.com wrote:
> No LVM over the two RAID 1's is more like RAID 1c which is just a
> concatenation of RAID 1's. You don't get the striping that you get in
> RAID 10.
>
>   
That's what I guessed.  Can anyone let me know if it's possible to set 
up a real md raid10?  Do I need to custom compile the kernel and do a 
kickstart install or something?

Russ
