From: =?ISO-8859-1?Q?Andreas_Dr=F6scher?= <raid@anticat.ch>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 22:24:43 +0100
Message-ID: <4CD7191B.8050305@anticat.ch>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org> <4CD6A141.5090601@anonymous.org.uk> <4CD6A7F0.7030300@turmel.org> <4CD6ACED.9030808@anonymous.org.uk> <4CD6BB2D.5020202@turmel.org> <4CD6C36C.1080200@anonymous.org.uk> <4CD6F259.6080408@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD6F259.6080408@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 07.11.2010 19:39, schrieb Phil Turmel:
> On 11/07/2010 10:19 AM, John Robinson wrote:
> I did another version, with regular expressions to accommodate the variations.
> Please give it a shot.

As I don't have sginfo on my system installed, I replaced the sn= line with

sn=`smartctl -i /dev/$bdev | awk '/Serial Number/{print $3}'`

Now the script works like a charm

Best Wishes
Andreas
