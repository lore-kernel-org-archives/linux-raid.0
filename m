From: David Greaves <david@dgreaves.com>
Subject: Re: disaster. raid1 drive failure rsync=DELAYED why?? please help
Date: Mon, 14 Mar 2005 09:49:09 +0000
Message-ID: <42355E15.8060109@dgreaves.com>
References: <200503122351.23430.mlaks@verizon.net> <423460EE.9070602@dgreaves.com> <200503140243.25308.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-8-I; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200503140243.25308.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mitchell Laks wrote:

>On Sunday 13 March 2005 10:49 am, David Greave wrote: Many Helpful remarks:
>  
>
>David I am grateful that you were there for me.
>  
>
No probs - we've all been there!

>My assessment (correct me if I am wrong) is that I have to rethink my 
>architecture. As I continue to work with software raid, I likely will have to 
>move the postgresql database to a separate partition, so I will not have 
>mixing of points of failure.  
>
Well, once things are calmer, post your layout and new thinking and I'm 
sure people will input.
Amongst other things, mdadm can allow you to keep 1 or more hot spares 
in a system that you can 'share' between multiple raid1 mirrors.
This kind of trick (learnt by hanging out here) may be the answer to 
muliple failures.

David
PS don't forget the mdadm upgrade.
