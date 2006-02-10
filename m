From: Luca Berra <bluca@comedia.it>
Subject: Re: heavy problem with raid initialisation
Date: Fri, 10 Feb 2006 19:23:48 +0100
Message-ID: <20060210182348.GA24513@percy.comedia.it>
References: <43EC66CC.4080001@inria.fr> <20060210122832.GA20903@percy.comedia.it> <43ECCC8A.8080106@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43ECCC8A.8080106@inria.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 10, 2006 at 06:25:30PM +0100, Guillaume Rousse wrote:
>Luca Berra wrote:
>> On Fri, Feb 10, 2006 at 11:11:24AM +0100, Guillaume Rousse wrote:
>>> Hello.
>>>
>>> I'm using software raid with mdadm 1.7.0 on a mandrake linux 10.1, but
>>> I'm facing heavy initialisation troubles. The first array /dev/md0 is
>>> automatically created and launched at startup (though mdadm -As in init
>>> scripts), but not the second array /dev/md1.
>>>
>>> mdadm --examine --scan --config=partitions creates the second array as
>>> /dev/.tmp.md1, which I can then assemble using an explicit mdadm -A
>>> /dev/sda2 /dev/sdb2 command, but this is unpractical and failproof :/
>>>
>> 
>> i think this issue was squashed in a newer version of mdadm
>> can you try rebuilding the current cooker rpm on 10.1 and try again.
>> i don't have a 10.1 laying around to test atm.
>I updated mdadm to 2.3.1, but the array is still seen as /dev/.tmp.md1.
>Putting this instead of /dev/md1 in /etc/mdadm.conf fix the issue, but
>it is quite inelegant :/

mmmm
try adding auto=yes to your array lines in mdadm.conf
or invoke mdadm -As -a

is /dev on udev ?

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
