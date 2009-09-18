From: "Majed B." <majedb@gmail.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Fri, 18 Sep 2009 23:13:29 +0300
Message-ID: <70ed7c3e0909181313p10abefe6u72329b6e8932cd2b@mail.gmail.com>
References: <h8nbt5$n8p$1@ger.gmane.org> <h8nfoe$n8p$3@ger.gmane.org>
	<alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
	<h8nreb$n8p$4@ger.gmane.org> <87ws3z5iro.fsf@frosties.localdomain>
	<1253106813.17888.9.camel@localhost> <70ed7c3e0909180117v725982dr5c6a344586ba36eb@mail.gmail.com>
	<1253273738.9662.636.camel@kiste> <4AB3C6E0.7010908@anonymous.org.uk>
	<87f94c370909181102y25ee0ba9o833ea2f9c09ff8d7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00032555a19623c95b0473dfc5ea
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370909181102y25ee0ba9o833ea2f9c09ff8d7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--00032555a19623c95b0473dfc5ea
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Greg,

You don't really need to use hdparm. You can use dd to overwrite the
bad sectors with zeros which forces the disk to remap the sector.

As for calculating the new data, a friend of mine wrote me a java
program that takes in any number of input files and XORs them, then
writes the output to a file.
The input files are the sectors' data from other disks.

I have attached the program in case any one is interested. Courtesy to
Eng. Hisham Farahat who wrote the program "sector xor, or sexor, as I
call it"

java -jar sexor.jar file1 file2 ... fileN

The output file will always be called "out" -- do not include it in
the input list.

On Fri, Sep 18, 2009 at 9:02 PM, Greg Freemyer <greg.freemyer@gmail.com> wr=
ote:
> All,
>
> I keep forgetting to ask, but the subject of this thread makes me
> wonder if you guys are familiar with the hdparm features of
> "--make-bad-sector", "--read-sector", and "--write-sector".
>
> I don't know if any of those can be used to force a sector to be
> remapped, but I could see a user space process like:
>
> identify corrupt sector
> hdparm --make-bad-sector =C2=A0 (to get it as corrupt as linux knows how)=
.
> calculate correct value
> write new value to sector the normal way (hopefully the drive will
> remap the bad sector)
>
> hdparm --read-sector will do a low level read of the sector, including
> the sector header and checksum as I understand it. =C2=A0I'm not sure all
> that gets back to userspace.
>
> hdparm --write-sector will force a sector to be rewritten. =C2=A0I don't
> believe it is meant to ever cause a sector remap. =C2=A0Of course you nev=
er
> know what a disk drive is going to do for any given command.
>
> Mark Lord is of course the expert on all things hdparm.
>
> Greg
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>



--=20
       Majed B.

--00032555a19623c95b0473dfc5ea
Content-Type: application/java-archive; name="sexor.jar"
Content-Disposition: attachment; filename="sexor.jar"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fzrd93wo0

UEsDBBQACAAIANlsMjsAAAAAAAAAAAAAAAAUAAQATUVUQS1JTkYvTUFOSUZFU1QuTUb+ygAA803M
y0xLLS7RDUstKs7Mz7NSMNQz4OXyTczM03XOSSwutlIITq3IL+Ll4uUCAFBLBwilHGUtLgAAACwA
AABQSwMECgAAAAAAwWgyO/Uz20DoAAAA6AAAAAoAAAAuY2xhc3NwYXRoPD94bWwgdmVyc2lvbj0i
MS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxjbGFzc3BhdGg+DQoJPGNsYXNzcGF0aGVudHJ5IGtp
bmQ9InNyYyIgcGF0aD0ic3JjIi8+DQoJPGNsYXNzcGF0aGVudHJ5IGtpbmQ9ImNvbiIgcGF0aD0i
b3JnLmVjbGlwc2UuamR0LmxhdW5jaGluZy5KUkVfQ09OVEFJTkVSIi8+DQoJPGNsYXNzcGF0aGVu
dHJ5IGtpbmQ9Im91dHB1dCIgcGF0aD0iYmluIi8+DQo8L2NsYXNzcGF0aD4NClBLAwQKAAAAAADB
aDI7PqqOO30BAAB9AQAACAAAAC5wcm9qZWN0PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0i
VVRGLTgiPz4NCjxwcm9qZWN0RGVzY3JpcHRpb24+DQoJPG5hbWU+U2V4b3I8L25hbWU+DQoJPGNv
bW1lbnQ+PC9jb21tZW50Pg0KCTxwcm9qZWN0cz4NCgk8L3Byb2plY3RzPg0KCTxidWlsZFNwZWM+
DQoJCTxidWlsZENvbW1hbmQ+DQoJCQk8bmFtZT5vcmcuZWNsaXBzZS5qZHQuY29yZS5qYXZhYnVp
bGRlcjwvbmFtZT4NCgkJCTxhcmd1bWVudHM+DQoJCQk8L2FyZ3VtZW50cz4NCgkJPC9idWlsZENv
bW1hbmQ+DQoJPC9idWlsZFNwZWM+DQoJPG5hdHVyZXM+DQoJCTxuYXR1cmU+b3JnLmVjbGlwc2Uu
amR0LmNvcmUuamF2YW5hdHVyZTwvbmF0dXJlPg0KCTwvbmF0dXJlcz4NCjwvcHJvamVjdERlc2Ny
aXB0aW9uPg0KUEsDBAoAAAAAADZsMjvuP4pOPAUAADwFAAALAAAAU2V4b3IuY2xhc3PK/rq+AAAA
MgBXBwACAQAFU2V4b3IHAAQBABBqYXZhL2xhbmcvT2JqZWN0AQAGPGluaXQ+AQADKClWAQAEQ29k
ZQoAAwAJDAAFAAYBAA9MaW5lTnVtYmVyVGFibGUBABJMb2NhbFZhcmlhYmxlVGFibGUBAAR0aGlz
AQAHTFNleG9yOwEABG1haW4BABYoW0xqYXZhL2xhbmcvU3RyaW5nOylWAQAKRXhjZXB0aW9ucwcA
EgEAE2phdmEvaW8vSU9FeGNlcHRpb24HABQBABdqYXZhL2lvL0ZpbGVJbnB1dFN0cmVhbQcAFgEA
DGphdmEvaW8vRmlsZQoAFQAYDAAFABkBABUoTGphdmEvbGFuZy9TdHJpbmc7KVYKABMAGwwABQAc
AQARKExqYXZhL2lvL0ZpbGU7KVYKABMAHgwAHwAgAQAEcmVhZAEABShbQilJCQAiACQHACMBABBq
YXZhL2xhbmcvU3lzdGVtDAAlACYBAANvdXQBABVMamF2YS9pby9QcmludFN0cmVhbTsHACgBABdq
YXZhL2xhbmcvU3RyaW5nQnVpbGRlcggAKgEABkZpbGU6IAoAJwAYCgAnAC0MAC4ALwEABmFwcGVu
ZAEALShMamF2YS9sYW5nL1N0cmluZzspTGphdmEvbGFuZy9TdHJpbmdCdWlsZGVyOwgAMQEADSBp
cyBwcm9jZXNzZWQKACcAMwwANAA1AQAIdG9TdHJpbmcBABQoKUxqYXZhL2xhbmcvU3RyaW5nOwoA
NwA5BwA4AQATamF2YS9pby9QcmludFN0cmVhbQwAOgAZAQAHcHJpbnRsbgcAPAEAGGphdmEvaW8v
RmlsZU91dHB1dFN0cmVhbQgAJQoAOwAbCgA7AEAMAEEAQgEABXdyaXRlAQAFKFtCKVYKADsARAwA
RQAGAQAFY2xvc2UIAEcBABhPdXRvdXQgZmlsZSBpcyBnZW5lcmF0ZWQBAARhcmdzAQATW0xqYXZh
L2xhbmcvU3RyaW5nOwEABmJ1ZmZlcgEAAltCAQADcmVzAQABagEAAUkBAAJpbgEAGUxqYXZhL2lv
L0ZpbGVJbnB1dFN0cmVhbTsBAAFpAQAaTGphdmEvaW8vRmlsZU91dHB1dFN0cmVhbTsBAA1TdGFj
a01hcFRhYmxlBwBLAQAKU291cmNlRmlsZQEAClNleG9yLmphdmEAIQABAAMAAAAAAAIAAQAFAAYA
AQAHAAAALwABAAEAAAAFKrcACLEAAAACAAoAAAAGAAEAAAAHAAsAAAAMAAEAAAAFAAwADQAAAAkA
DgAPAAIAEAAAAAQAAQARAAcAAAFNAAYABgAAAJIRAgC8CEwRAgC8CE0DPqcAW7sAE1m7ABVZKh0y
twAXtwAaOgQZBCu2AB1XAzYFpwAULBUFLBUFMysVBTOCkVSEBQEVBSu+of/rsgAhuwAnWRIptwAr
Kh0ytgAsEjC2ACy2ADK2ADaEAwEdKr6h/6W7ADtZuwAVWRI9twAXtwA+Ti0stgA/LbYAQ7IAIRJG
tgA2sQAAAAMACgAAAD4ADwAAAA4ABgAPAAwAEAARABEAJAASACsAEwAxABQAPwATAEkAFgBmABAA
bwAaAIAAGwCFABwAiQAdAJEAMwALAAAASAAHAAAAkgBIAEkAAAAGAIwASgBLAAEADACGAEwASwAC
AA4AYQBNAE4AAwAkAEIATwBQAAQALgAbAFEATgAFAIAAEgAlAFIAAwBTAAAAFwAE/gARBwBUBwBU
Af0AHwcAEwEQ+QAmAAEAVQAAAAIAVlBLAwQKAAAAAAA2bDI76PLWxucFAADnBQAACgAAAFNleG9y
LmphdmFpbXBvcnQgamF2YS5pby5GaWxlOw0KaW1wb3J0IGphdmEuaW8uRmlsZUlucHV0U3RyZWFt
Ow0KaW1wb3J0IGphdmEuaW8uRmlsZU5vdEZvdW5kRXhjZXB0aW9uOw0KaW1wb3J0IGphdmEuaW8u
RmlsZU91dHB1dFN0cmVhbTsNCmltcG9ydCBqYXZhLmlvLklPRXhjZXB0aW9uOw0KDQpwdWJsaWMg
Y2xhc3MgU2V4b3Igew0KDQoJLyoqDQoJICogQHBhcmFtIGFyZ3MNCgkgKiBAdGhyb3dzIElPRXhj
ZXB0aW9uDQoJICovDQoJcHVibGljIHN0YXRpYyB2b2lkIG1haW4oU3RyaW5nW10gYXJncykgdGhy
b3dzIElPRXhjZXB0aW9uIHsNCgkJYnl0ZSBidWZmZXJbXSA9IG5ldyBieXRlWzUxMl07DQoJCWJ5
dGUgcmVzW10gPSBuZXcgYnl0ZVs1MTJdOw0KCQlmb3IgKGludCBqID0gMDsgaiA8IGFyZ3MubGVu
Z3RoOyBqKyspIHsNCgkJCUZpbGVJbnB1dFN0cmVhbSBpbiA9IG5ldyBGaWxlSW5wdXRTdHJlYW0o
bmV3IEZpbGUoYXJnc1tqXSkpOw0KCQkJaW4ucmVhZChidWZmZXIpOw0KCQkJZm9yIChpbnQgaSA9
IDA7IGkgPCBidWZmZXIubGVuZ3RoOyBpKyspIHsNCgkJCQlyZXNbaV0gPSAoYnl0ZSkgKHJlc1tp
XSBeIGJ1ZmZlcltpXSk7DQoJCQl9DQoJCQlTeXN0ZW0ub3V0LnByaW50bG4oIkZpbGU6ICIrYXJn
c1tqXSsiIGlzIHByb2Nlc3NlZCIpOw0KDQoJCX0NCg0KCQlGaWxlT3V0cHV0U3RyZWFtIG91dCA9
IG5ldyBGaWxlT3V0cHV0U3RyZWFtKG5ldyBGaWxlKCJvdXQiKSk7DQoJCW91dC53cml0ZShyZXMp
Ow0KCQlvdXQuY2xvc2UoKTsNCgkJU3lzdGVtLm91dC5wcmludGxuKCJPdXRvdXQgZmlsZSBpcyBn
ZW5lcmF0ZWQiKTsNCg0KCQkvLyBGaWxlSW5wdXRTdHJlYW0gaW4gPSBuZXcgRmlsZUlucHV0U3Ry
ZWFtKG5ldyBGaWxlKCIxIikpOw0KCQkvLyBGaWxlSW5wdXRTdHJlYW0gaW4yID0gbmV3IEZpbGVJ
bnB1dFN0cmVhbShuZXcgRmlsZSgiMiIpKTsNCgkJLy8gYnl0ZSBidWZmZXJbXSA9IG5ldyBieXRl
WzUxMl07DQoJCS8vIGJ5dGUgYnVmZmVyMltdID0gbmV3IGJ5dGVbNTEyXTsNCgkJLy8gYnl0ZSBy
ZXNbXSA9IG5ldyBieXRlWzUxMl07DQoJCS8vIGluLnJlYWQoYnVmZmVyKTsNCgkJLy8gaW4yLnJl
YWQoYnVmZmVyMik7DQoJCS8vIGZvciAoaW50IGkgPSAwOyBpIDwgYnVmZmVyLmxlbmd0aDsgaSsr
KSB7DQoJCS8vIFN5c3RlbS5vdXQucHJpbnRmKCIlZFx0IixidWZmZXJbaV0pOw0KCQkvLyB9DQoJ
CS8vIFN5c3RlbS5vdXQucHJpbnRsbigpOw0KCQkvLyBmb3IgKGludCBpID0gMDsgaSA8IGJ1ZmZl
ci5sZW5ndGg7IGkrKykgew0KCQkvLyBTeXN0ZW0ub3V0LnByaW50ZigiJWRcdCIsYnVmZmVyMltp
XSk7DQoJCS8vIH0NCgkJLy8gU3lzdGVtLm91dC5wcmludGxuKCk7DQoJCS8vIGZvciAoaW50IGkg
PSAwOyBpIDwgYnVmZmVyLmxlbmd0aDsgaSsrKSB7DQoJCS8vIFN5c3RlbS5vdXQucHJpbnRmKCIl
ZFx0IixidWZmZXIyW2ldXmJ1ZmZlcltpXSk7DQoJCS8vIHJlc1tpXT0oYnl0ZSkoYnVmZmVyMltp
XV5idWZmZXJbaV0pOw0KCQkvLyB9DQoNCgl9DQoNCn0NClBLAQIUABQACAAIANlsMjulHGUtLgAA
ACwAAAAUAAQAAAAAAAAAAAAAAAAAAABNRVRBLUlORi9NQU5JRkVTVC5NRv7KAABQSwECCgAKAAAA
AADBaDI79TPbQOgAAADoAAAACgAAAAAAAAAAAAAAAAB0AAAALmNsYXNzcGF0aFBLAQIKAAoAAAAA
AMFoMjs+qo47fQEAAH0BAAAIAAAAAAAAAAAAAAAAAIQBAAAucHJvamVjdFBLAQIKAAoAAAAAADZs
MjvuP4pOPAUAADwFAAALAAAAAAAAAAAAAAAAACcDAABTZXhvci5jbGFzc1BLAQIKAAoAAAAAADZs
Mjvo8tbG5wUAAOcFAAAKAAAAAAAAAAAAAAAAAIwIAABTZXhvci5qYXZhUEsFBgAAAAAFAAUAJQEA
AJsOAAAAAA==
--00032555a19623c95b0473dfc5ea--
