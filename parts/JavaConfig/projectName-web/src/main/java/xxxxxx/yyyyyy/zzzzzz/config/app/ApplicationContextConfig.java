package xxxxxx.yyyyyy.zzzzzz.config.app;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Import;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.core.io.Resource;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.DelegatingPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.crypto.password.Pbkdf2PasswordEncoder;
import org.terasoluna.gfw.common.exception.ExceptionCodeResolver;
import org.terasoluna.gfw.common.exception.ExceptionLogger;
import org.terasoluna.gfw.common.exception.SimpleMappingExceptionCodeResolver;
import org.terasoluna.gfw.web.exception.ExceptionLoggingFilter;

/**
 * Application context.
 */
@Configuration
@EnableAspectJAutoProxy
@Import({ProjectNameDomainConfig.class})
public class ApplicationContextConfig {

    // @formatter:off
    /**
     * Configure {@link PasswordEncoder} bean.
     * @return Bean of configured {@link DelegatingPasswordEncoder}
     */
    @Bean("passwordEncoder")
    public PasswordEncoder passwordEncoder() {
        Map<String, PasswordEncoder> idToPasswordEncoder = new HashMap<>();
        idToPasswordEncoder.put("pbkdf2", pbkdf2PasswordEncoder());
        idToPasswordEncoder.put("bcrypt", bCryptPasswordEncoder());
        /* When using commented out PasswordEncoders, you need to add bcprov-jdk18on.jar to the dependency.
        idToPasswordEncoder.put("argon2", argon2PasswordEncoder());
        idToPasswordEncoder.put("scrypt", sCryptPasswordEncoder());
        */
        return new DelegatingPasswordEncoder("pbkdf2", idToPasswordEncoder);
    }
    // @formatter:on

    /**
     * Configure {@link Pbkdf2PasswordEncoder} bean.
     * @return Bean of configured {@link Pbkdf2PasswordEncoder}
     */
    @Bean
    public Pbkdf2PasswordEncoder pbkdf2PasswordEncoder() {
        return Pbkdf2PasswordEncoder.defaultsForSpringSecurity_v5_8();
    }

    /**
     * Configure {@link BCryptPasswordEncoder} bean.
     * @return Bean of configured {@link BCryptPasswordEncoder}
     */
    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // @formatter:off
    /* When using commented out PasswordEncoders, you need to add bcprov-jdk18on.jar to the dependency.
    @Bean
    public Argon2PasswordEncoder argon2PasswordEncoder() {
        return Argon2PasswordEncoder.defaultsForSpringSecurity_v5_8();
    }
    @Bean
    public SCryptPasswordEncoder sCryptPasswordEncoder() {
        return SCryptPasswordEncoder.defaultsForSpringSecurity_v5_8();
    }
    */
    // @formatter:on

    /**
     * Configure {@link PropertySourcesPlaceholderConfigurer} bean.
     * @param properties Property files to be read
     * @return Bean of configured {@link PropertySourcesPlaceholderConfigurer}
     */
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer(
            @Value("classpath*:/META-INF/spring/*.properties") Resource... properties) {
        PropertySourcesPlaceholderConfigurer bean = new PropertySourcesPlaceholderConfigurer();
        bean.setLocations(properties);
        return bean;
    }

    /**
     * Configure {@link MessageSource} bean.
     * @return Bean of configured {@link ResourceBundleMessageSource}
     */
    @Bean("messageSource")
    public MessageSource messageSource() {
        ResourceBundleMessageSource bean = new ResourceBundleMessageSource();
        bean.setBasenames("i18n/application-messages");
        return bean;
    }

    /**
     * Configure {@link ExceptionCodeResolver} bean.
     * @return Bean of configured {@link SimpleMappingExceptionCodeResolver}
     */
    @Bean("exceptionCodeResolver")
    public ExceptionCodeResolver exceptionCodeResolver() {
        LinkedHashMap<String, String> map = new LinkedHashMap<>();
        map.put("ResourceNotFoundException", "e.xx.fw.5001");
        map.put("InvalidTransactionTokenException", "e.xx.fw.7001");
        map.put("BusinessException", "e.xx.fw.8001");
        map.put(".DataAccessException", "e.xx.fw.9002");
        SimpleMappingExceptionCodeResolver bean = new SimpleMappingExceptionCodeResolver();
        bean.setExceptionMappings(map);
        bean.setDefaultExceptionCode("e.xx.fw.9001");
        return bean;
    }

    /**
     * Configure {@link ExceptionLogger} bean.
     * @return Bean of configured {@link ExceptionLogger}
     */
    @Bean("exceptionLogger")
    public ExceptionLogger exceptionLogger() {
        ExceptionLogger bean = new ExceptionLogger();
        bean.setExceptionCodeResolver(exceptionCodeResolver());
        return bean;
    }

    /**
     * Configure {@link ExceptionLoggingFilter} bean.
     * @return Bean of configured {@link ExceptionLoggingFilter}
     */
    @Bean("exceptionLoggingFilter")
    public ExceptionLoggingFilter exceptionLoggingFilter() {
        ExceptionLoggingFilter bean = new ExceptionLoggingFilter();
        bean.setExceptionLogger(exceptionLogger());
        return bean;
    }
}
