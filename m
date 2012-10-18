From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Thu, 18 Oct 2012 13:54:59 -0600
Message-ID: <3286E6F7-0982-4A87-A83C-5D78B22EE437@colorremedies.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com> <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com> <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com> <235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com> <CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com> <D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com> <CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com> <507FEE52.50103@hardwarefreak.com> <CADNH=7FKd9LuUzwnQ7W4Evo_PzGRjY8nK6u1R3AMvzq17FMe=w@mail.gmail.com> <CADNH=7HEBDGrN+2SpLB30mAN0nW0ky=KGwCgnxeY4OSejFr1yw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HEBDGrN+2SpLB30mAN0nW0ky=KGwCgnxeY4OSejFr1yw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 18, 2012, at 11:11 AM, Mathias Bur=E9n wrote:

> Just to follow up, the reshape succeeded and I'll now shutdown and RM=
A
> /dev/sde. Thanks all for the answers.

Yeah but two days later and you still are critically degraded without e=
ither failed disk replaced and rebuilding. You're one tiny problem away=
 from that whole array collapsing and you're worried about this one fus=
sy disk? I don't understand your delay in immediately getting a replace=
ment drive in this array unless you really don't care about the data at=
 all, in which case why have a RAID6?

Sure, what are the odds of a 3rd drive dying=85 *shrug* Seems like an u=
nwise risk tempting fate like this.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
