From: alpha lin <lin.alpha@gmail.com>
Subject: Re: update mdadm version to 3.3.2 in Centos 6.4
Date: Mon, 16 Feb 2015 02:48:46 +0800
Message-ID: <CAKtQofv_Qsh2vw8=_980ncUuzbPKT7K6xGJBkXwCXLQktYGUng@mail.gmail.com>
References: <CAKtQoftv3uf-Y1va7QV=qFiJZO0CdSJ7QtfHj7P1Mg5oyj0fRw@mail.gmail.com>
	<wrfjtwz3t9na.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjtwz3t9na.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jes,

   I have my Oracle database running on Centos 6.4. There will be
great if I can stay in  Centos 6.4 rather than upgrade to Centos 6.6.

Alpha.

On Tue, Feb 3, 2015 at 9:19 PM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> alpha lin <lin.alpha@gmail.com> writes:
>> Hi All,
>>
>>     I would like to know the possibility of update the mdadm package
>> from 3.2.5 to 3.3.2 in Redhat Centos 6.4 x64 system.
>>     The problem I have is I found that I can create a raid volume
>> without any problem. But when reboot the system. The md volume become
>> inactive.
>>     Below is my step:
>>     1. Check out mdadm package from the github.
>>     2. unzip the mdadm package and execute "make" and "make install"
>>     3. reboot.
>>     4. after system reboot, run mdadm to create a imsm RAID Volume.
>>    [root@localhost rules.d]# mdadm --version
>>     mdadm - v3.3.2 - 21st August 2014
>
> Any reason why you haven't upgraded to centos 6.6? 6.4 is ancient, and
> 6.6 will at least come with mdadm-3.3.
>
> Jes
>
>
