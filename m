From: Danilo Godec <danilo.godec@agenda.si>
Subject: Re: SATA errors?
Date: Fri, 03 Oct 2008 11:52:02 +0200
Message-ID: <48E5EB42.9050106@agenda.si>
References: <48E34221.1000008@agenda.si> <20081001100833.3253724847@gemini.denx.de> <48E353D5.1060908@agenda.si> <A20315AE59B5C34585629E258D76A97C02180F8B@34093-C3-EVS3.exchange.rackspace.com> <48E36A61.4020903@dgreaves.com> <A20315AE59B5C34585629E258D76A97C021D052A@34093-C3-EVS3.exchange.rackspace.com> <48E3ED4D.6000409@agenda.si> <alpine.DEB.1.10.0810011803180.30506@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040808000909020200010208"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810011803180.30506@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040808000909020200010208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Well, it's been two full days (48+ hours) and no error... I guess
smartctrl doesn't like WDC drives (or better yet, vise versa).

  Danilo


Justin Piszcz pravi:
>
>
> On Wed, 1 Oct 2008, Danilo Godec wrote:
>
>> 1. I will get a new server in a couple of days and then I'll be able
>> to move the Xen VM's from the 'problematic' server. Then I'll see
>> what can be updated/upgraded.
>> 2. The errors are pretty much random and there is nothing in the cron
>> at all. I don't think Xen VM's could do anything with the physical
>> drive, so their crons shouldn't be relevant.
>> 3. It's not really a problem that we (the users) would feel. It's
>> just the logs that got me worried (I don't like unexplainable hard
>> drive errors).
>> 4. As said before, I changed the scripts to use 'smartctl' with one
>> of the other drives. So far it seems better - there hasn't been a
>> single error in 12 hours.
>>>
>> If it turns out that 'smartctl' was causing this I'll report it to
>> 'smartmontools' guys.
>>
>> Thanks for the help, Danilo
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> I actually turned off smart(daemon) /etc - the problems still persist
> for me..
>
> Justin.


-- 
Danilo Godec, sistemska podpora

Predlog! Obiscite prenovljeno spletno stran http://www.agenda.si

ODPRTA KODA IN LINUX
STORITVE : POSLOVNE RESITVE : UPRAVLJANJE IT : INFRASTRUKTURA IT : IZOBRAZEVANJE : PROGRAMSKA OPREMA

Visit our updated web page at http://www.agenda.si

OPEN SOURCE AND LINUX
SERVICES : BUSINESS SOLUTIONS : IT MANAGEMENT : IT INFRASTRUCTURE : TRAINING : SOFTWARE 


--------------040808000909020200010208
Content-Type: text/x-vcard; charset=utf-8;
 name="danilo_godec.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="danilo_godec.vcf"

begin:vcard
fn:Danilo Godec
n:Godec;Danilo
org:Agenda OpenSystems
adr:;;Ul. Pohorskega bataljona 49;Maribor;;2000;Slovenia
email;internet:danilo.godec@agenda.si
tel;work:+386 2 4216138
tel;fax:+386 2 4216141
tel;cell:+386 40 618802
x-mozilla-html:FALSE
url:http://www.agenda.si/
version:2.1
end:vcard


--------------040808000909020200010208--
