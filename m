From: David Greaves <david@dgreaves.com>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Sun, 13 Mar 2005 15:23:26 +0000
Message-ID: <42345AEE.1010705@dgreaves.com>
References: <200503122351.23430.mlaks@verizon.net> <42340CA3.8020900@dgreaves.com> <200503130932.50098.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-8-I; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503130932.50098.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:

>On Sunday 13 March 2005 04:49 am, you wrote:
>  
>
>>kernel version, mdadm version?
>>    
>>
>
>debian sarge:
>
>wustl@A1:~$ uname -a
>Linux A1 2.6.8-1-386 #1 Thu Nov 25 04:24:08 UTC 2004 i686 GNU/Linux
>wustl@A1:~$ export COLUMNS=200;dpkg -l|grep mdadm
>ii  mdadm                                        1.8.1-1   
>
Ah!
This is an 'experimental' verion of mdadm
I'll interrupt the answer to your other emails I'm writing for now...
upgrade to mdadm 1.9 immediately! (or down to 1.8.0 doesn't matter)

The debian maintainer should have read the release notes - bad mainter!!

This won't affect the resync=DELAYED; that's in the kernel

David
