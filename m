From: Gil <gil@fooplanet.com>
Subject: Re: Problems with invalid superblock
Date: Fri, 17 Feb 2006 14:32:05 -0800
Message-ID: <43F64EE5.7070408@fooplanet.com>
References: <43F64759.1060503@scinergy.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43F64759.1060503@scinergy.com.br>
Sender: linux-raid-owner@vger.kernel.org
To: william@scinergy.com.br
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

William Marques wrote:
> Hi,
> 
> I trying to setup a raid0 without success, using the mdadm 2.3.1
> package, compiled from sources.
> No matters if its linear or stripping raid0 mode, the errors are the same:
> 
> master# mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2
> /dev/sda2 /dev/sda3
> master:~# mdadm -E /dev/md0
> mdadm: No md superblock detected on /dev/md0.

Try mdadm -E /dev/sda2 or mdadm -E /dev/sda3.

--Gil
