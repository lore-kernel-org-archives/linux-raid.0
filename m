From: Guillaume Rousse <Guillaume.Rousse@inria.fr>
Subject: Re: heavy problem with raid initialisation
Date: Wed, 12 Apr 2006 16:02:38 +0200
Message-ID: <443D087E.2000603@inria.fr>
References: <43EC66CC.4080001@inria.fr> <20060210122832.GA20903@percy.comedia.it> <43ECCC8A.8080106@inria.fr> <20060210182348.GA24513@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060210182348.GA24513@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For sake of list archive completness :)

Luca Berra wrote:
>> I updated mdadm to 2.3.1, but the array is still seen as /dev/.tmp.md1.
>> Putting this instead of /dev/md1 in /etc/mdadm.conf fix the issue, but
>> it is quite inelegant :/
> 
> mmmm
> try adding auto=yes to your array lines in mdadm.conf
> or invoke mdadm -As -a
auto=yes solved the issue, thanks.

> is /dev on udev ?
Yes
