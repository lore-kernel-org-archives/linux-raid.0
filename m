From: Phil Turmel <philip@turmel.org>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 13:02:09 -0500
Message-ID: <4D6005A1.7040307@turmel.org>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com> <4D5FE3D6.8070006@anonymous.org.uk> <4D5FF386.6070003@turmel.org> <4D5FFCEC.9040207@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5FFCEC.9040207@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

(whoops, dropped the list.  Sorry about the dupe, John)

On 02/19/2011 12:25 PM, John Robinson wrote:
[trim /]
> So I changed the find regex as follows:
> 
> find /sys/devices/ -regex '.+/scsi_host\(:block\|:host[0-9]+\)?'
> 
> though I'd be interested to know why the simpler:
> 
> find /sys/devices/ -name 'scsi_host*'
> 
> isn't sufficient?

It probably is fine, and does work on all my machines close at hand.  I did a fair amount of rework after the last public discussion, and I try to be conservative with wildcard matches.  I'll use it for a while, and see if it bites.

Phil
